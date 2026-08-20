import Sound
import lean_certs.cert_42_158

open CertVerify

theorem H42_gt_158 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 42) (d := 158) (c := cert_42_158) (by native_decide)
