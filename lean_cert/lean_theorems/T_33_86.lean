import Sound
import lean_certs.cert_33_86

open CertVerify

theorem H33_gt_86 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 33) (d := 86) (c := cert_33_86) (by native_decide)
