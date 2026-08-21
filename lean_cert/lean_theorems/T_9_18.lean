import Sound
import lean_certs.cert_9_18

open CertVerify

theorem H9_gt_18 : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 9) (d := 18) (c := cert_9_18) (by native_decide)
