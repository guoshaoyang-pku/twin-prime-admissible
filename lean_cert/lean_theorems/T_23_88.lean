import Sound
import lean_certs.cert_23_88

open CertVerify

theorem H23_gt_88 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 23) (d := 88) (c := cert_23_88) (by native_decide)
