import Sound
import lean_certs.cert_40_90

open CertVerify

theorem H40_gt_90 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 40) (d := 90) (c := cert_40_90) (by native_decide)
