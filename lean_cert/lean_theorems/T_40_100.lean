import Sound
import lean_certs.cert_40_100

open CertVerify

theorem H40_gt_100 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 40) (d := 100) (c := cert_40_100) (by native_decide)
