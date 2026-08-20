import Sound
import lean_certs.cert_34_110

open CertVerify

theorem H34_gt_110 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 34) (d := 110) (c := cert_34_110) (by native_decide)
