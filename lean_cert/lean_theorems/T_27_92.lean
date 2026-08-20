import Sound
import lean_certs.cert_27_92

open CertVerify

theorem H27_gt_92 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 27) (d := 92) (c := cert_27_92) (by native_decide)
