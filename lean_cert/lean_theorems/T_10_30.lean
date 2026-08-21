import Sound
import lean_certs.cert_10_30

open CertVerify

theorem H10_gt_30 : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 10) (d := 30) (c := cert_10_30) (by native_decide)
