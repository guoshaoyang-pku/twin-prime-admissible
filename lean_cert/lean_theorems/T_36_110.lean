import Sound
import lean_certs.cert_36_110

open CertVerify

theorem H36_gt_110 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 36) (d := 110) (c := cert_36_110) (by native_decide)
