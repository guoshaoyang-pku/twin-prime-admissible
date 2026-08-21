import Sound
import lean_certs.cert_6_10

open CertVerify

theorem H6_gt_10 : ¬ ∃ t : List Nat, admissible 6 t = true ∧ diameter t ≤ 10 := by
  exact certValidRoot_sound (k := 6) (d := 10) (c := cert_6_10) (by native_decide)
