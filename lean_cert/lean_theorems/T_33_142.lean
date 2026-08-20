import Sound
import lean_certs.cert_33_142

open CertVerify

theorem H33_gt_142 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 33) (d := 142) (c := cert_33_142) (by native_decide)
