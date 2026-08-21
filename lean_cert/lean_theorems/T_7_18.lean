import Sound
import lean_certs.cert_7_18

open CertVerify

theorem H7_gt_18 : ¬ ∃ t : List Nat, admissible 7 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 7) (d := 18) (c := cert_7_18) (by native_decide)
