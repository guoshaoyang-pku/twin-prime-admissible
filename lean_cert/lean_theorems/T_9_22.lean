import Sound
import lean_certs.cert_9_22

open CertVerify

theorem H9_gt_22 : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 9) (d := 22) (c := cert_9_22) (by native_decide)
