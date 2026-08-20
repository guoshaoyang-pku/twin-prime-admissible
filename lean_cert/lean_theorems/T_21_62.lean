import Sound
import lean_certs.cert_21_62

open CertVerify

theorem H21_gt_62 : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 21) (d := 62) (c := cert_21_62) (by native_decide)
