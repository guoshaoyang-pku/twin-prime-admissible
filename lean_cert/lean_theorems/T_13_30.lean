import Sound
import lean_certs.cert_13_30

open CertVerify

theorem H13_gt_30 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 30 := by
  exact certValidRoot_sound (k := 13) (d := 30) (c := cert_13_30) (by native_decide)
