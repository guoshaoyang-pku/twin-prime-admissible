import Sound
import lean_certs.cert_36_150

open CertVerify

theorem H36_gt_150 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 36) (d := 150) (c := cert_36_150) (by native_decide)
