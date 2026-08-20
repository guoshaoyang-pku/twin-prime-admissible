import Sound
import lean_certs.cert_48_114

open CertVerify

theorem H48_gt_114 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 48) (d := 114) (c := cert_48_114) (by native_decide)
