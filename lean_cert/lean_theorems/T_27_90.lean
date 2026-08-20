import Sound
import lean_certs.cert_27_90

open CertVerify

theorem H27_gt_90 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 27) (d := 90) (c := cert_27_90) (by native_decide)
