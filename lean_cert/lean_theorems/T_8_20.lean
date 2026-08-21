import Sound
import lean_certs.cert_8_20

open CertVerify

theorem H8_gt_20 : ¬ ∃ t : List Nat, admissible 8 t = true ∧ diameter t ≤ 20 := by
  exact certValidRoot_sound (k := 8) (d := 20) (c := cert_8_20) (by native_decide)
