import Sound
import lean_certs.cert_33_104

open CertVerify

theorem H33_gt_104 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 104 := by
  exact certValidRoot_sound (k := 33) (d := 104) (c := cert_33_104) (by native_decide)
