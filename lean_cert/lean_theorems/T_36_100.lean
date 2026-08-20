import Sound
import lean_certs.cert_36_100

open CertVerify

theorem H36_gt_100 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 36) (d := 100) (c := cert_36_100) (by native_decide)
