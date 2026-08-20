import Sound
import lean_certs.cert_42_172

open CertVerify

theorem H42_gt_172 : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 172 := by
  exact certValidRoot_sound (k := 42) (d := 172) (c := cert_42_172) (by native_decide)
