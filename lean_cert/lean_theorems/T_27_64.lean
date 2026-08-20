import Sound
import lean_certs.cert_27_64

open CertVerify

theorem H27_gt_64 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 27) (d := 64) (c := cert_27_64) (by native_decide)
