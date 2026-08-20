import Sound
import lean_certs.cert_40_120

open CertVerify

theorem H40_gt_120 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 40) (d := 120) (c := cert_40_120) (by native_decide)
