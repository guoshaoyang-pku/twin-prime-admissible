import Sound
import lean_certs.cert_9_16

open CertVerify

theorem H9_gt_16 : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 16 := by
  exact certValidRoot_sound (k := 9) (d := 16) (c := cert_9_16) (by native_decide)
