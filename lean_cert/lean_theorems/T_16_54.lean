import Sound
import lean_certs.cert_16_54

open CertVerify

theorem H16_gt_54 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 54 := by
  exact certValidRoot_sound (k := 16) (d := 54) (c := cert_16_54) (by native_decide)
