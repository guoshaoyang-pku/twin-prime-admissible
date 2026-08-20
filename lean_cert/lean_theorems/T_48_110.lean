import Sound
import lean_certs.cert_48_110

open CertVerify

theorem H48_gt_110 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 48) (d := 110) (c := cert_48_110) (by native_decide)
