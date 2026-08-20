import Sound
import lean_certs.cert_23_62

open CertVerify

theorem H23_gt_62 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 23) (d := 62) (c := cert_23_62) (by native_decide)
