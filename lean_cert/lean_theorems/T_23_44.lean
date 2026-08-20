import Sound
import lean_certs.cert_23_44

open CertVerify

theorem H23_gt_44 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 23) (d := 44) (c := cert_23_44) (by native_decide)
