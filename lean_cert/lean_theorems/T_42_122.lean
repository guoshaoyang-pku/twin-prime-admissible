import Sound
import lean_certs.cert_42_122

open CertVerify

theorem H42_gt_122 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 42) (d := 122) (c := cert_42_122) (by native_decide)
