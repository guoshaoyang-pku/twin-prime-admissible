import Sound
import lean_certs.cert_26_110

open CertVerify

theorem H26_gt_110 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 26) (d := 110) (c := cert_26_110) (by native_decide)
