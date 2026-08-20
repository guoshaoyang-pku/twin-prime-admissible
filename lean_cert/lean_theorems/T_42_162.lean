import Sound
import lean_certs.cert_42_162

open CertVerify

theorem H42_gt_162 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 42) (d := 162) (c := cert_42_162) (by native_decide)
