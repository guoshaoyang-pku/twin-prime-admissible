import Sound
import lean_certs.cert_5_10

open CertVerify

theorem H5_gt_10 : ¬ ∃ t : List Nat, admissible 5 t = true ∧ diameter t ≤ 10 := by
  exact certValidRoot_sound (k := 5) (d := 10) (c := cert_5_10) (by native_decide)
