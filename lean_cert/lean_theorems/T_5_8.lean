import Sound
import lean_certs.cert_5_8

open CertVerify

theorem H5_gt_8 : ¬ ∃ t : List Nat, admissible 5 t = true ∧ diameter t ≤ 8 := by
  exact certValidRoot_sound (k := 5) (d := 8) (c := cert_5_8) (by native_decide)
