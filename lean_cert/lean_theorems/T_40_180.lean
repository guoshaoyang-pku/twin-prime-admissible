import Sound
import lean_certs.cert_40_180

open CertVerify

theorem H40_gt_180 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 40) (d := 180) (c := cert_40_180) (by native_decide)
