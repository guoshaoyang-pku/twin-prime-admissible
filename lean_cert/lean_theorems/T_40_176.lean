import Sound
import lean_certs.cert_40_176

open CertVerify

theorem H40_gt_176 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 40) (d := 176) (c := cert_40_176) (by native_decide)
