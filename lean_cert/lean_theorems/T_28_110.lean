import Sound
import lean_certs.cert_28_110

open CertVerify

theorem H28_gt_110 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 28) (d := 110) (c := cert_28_110) (by native_decide)
