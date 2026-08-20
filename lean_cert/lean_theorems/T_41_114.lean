import Sound
import lean_certs.cert_41_114

open CertVerify

theorem H41_gt_114 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 41) (d := 114) (c := cert_41_114) (by native_decide)
