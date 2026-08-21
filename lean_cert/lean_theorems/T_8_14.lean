import Sound
import lean_certs.cert_8_14

open CertVerify

theorem H8_gt_14 : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 14 := by
  exact certValidRoot_sound (k := 8) (d := 14) (c := cert_8_14) (by native_decide)
