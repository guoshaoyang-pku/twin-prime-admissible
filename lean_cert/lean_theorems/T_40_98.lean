import Sound
import lean_certs.cert_40_98

open CertVerify

theorem H40_gt_98 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 40) (d := 98) (c := cert_40_98) (by native_decide)
