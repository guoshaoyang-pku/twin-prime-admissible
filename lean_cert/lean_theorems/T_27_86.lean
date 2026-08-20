import Sound
import lean_certs.cert_27_86

open CertVerify

theorem H27_gt_86 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 27) (d := 86) (c := cert_27_86) (by native_decide)
