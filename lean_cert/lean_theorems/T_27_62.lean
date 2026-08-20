import Sound
import lean_certs.cert_27_62

open CertVerify

theorem H27_gt_62 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 27) (d := 62) (c := cert_27_62) (by native_decide)
