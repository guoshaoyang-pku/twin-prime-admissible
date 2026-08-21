import Sound
import lean_certs.cert_10_22

open CertVerify

theorem H10_gt_22 : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 10) (d := 22) (c := cert_10_22) (by native_decide)
