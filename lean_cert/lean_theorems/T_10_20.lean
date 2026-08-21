import Sound
import lean_certs.cert_10_20

open CertVerify

theorem H10_gt_20 : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 20 := by
  exact certValidRoot_sound (k := 10) (d := 20) (c := cert_10_20) (by native_decide)
