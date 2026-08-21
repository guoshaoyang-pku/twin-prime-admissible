import Sound
import lean_certs.cert_16_42

open CertVerify

theorem H16_gt_42 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 16) (d := 42) (c := cert_16_42) (by native_decide)
