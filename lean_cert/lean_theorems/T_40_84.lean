import Sound
import lean_certs.cert_40_84

open CertVerify

theorem H40_gt_84 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 40) (d := 84) (c := cert_40_84) (by native_decide)
