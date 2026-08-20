import Sound
import lean_certs.cert_49_114

open CertVerify

theorem H49_gt_114 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 49) (d := 114) (c := cert_49_114) (by native_decide)
