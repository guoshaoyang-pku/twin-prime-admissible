import Sound
import lean_certs.cert_27_72

open CertVerify

theorem H27_gt_72 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 72 := by
  exact certValidRoot_sound (k := 27) (d := 72) (c := cert_27_72) (by native_decide)
