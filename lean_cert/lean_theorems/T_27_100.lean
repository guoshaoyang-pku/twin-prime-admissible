import Sound
import lean_certs.cert_27_100

open CertVerify

theorem H27_gt_100 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 27) (d := 100) (c := cert_27_100) (by native_decide)
