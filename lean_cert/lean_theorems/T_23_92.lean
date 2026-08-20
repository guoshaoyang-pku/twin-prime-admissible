import Sound
import lean_certs.cert_23_92

open CertVerify

theorem H23_gt_92 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 23) (d := 92) (c := cert_23_92) (by native_decide)
