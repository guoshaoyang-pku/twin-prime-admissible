import Sound
import lean_certs.cert_8_18

open CertVerify

theorem H8_gt_18 : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 8) (d := 18) (c := cert_8_18) (by native_decide)
