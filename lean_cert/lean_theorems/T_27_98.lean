import Sound
import lean_certs.cert_27_98

open CertVerify

theorem H27_gt_98 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 27) (d := 98) (c := cert_27_98) (by native_decide)
