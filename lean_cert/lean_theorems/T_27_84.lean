import Sound
import lean_certs.cert_27_84

open CertVerify

theorem H27_gt_84 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 27) (d := 84) (c := cert_27_84) (by native_decide)
