import Sound
import lean_certs.cert_41_110

open CertVerify

theorem H41_gt_110 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 41) (d := 110) (c := cert_41_110) (by native_decide)
