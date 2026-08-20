import Sound
import lean_certs.cert_42_190

open CertVerify

theorem H42_gt_190 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 42) (d := 190) (c := cert_42_190) (by native_decide)
